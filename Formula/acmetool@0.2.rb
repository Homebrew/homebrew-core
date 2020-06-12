class AcmetoolAT02 < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt) v2"
  homepage "https://github.com/hlandau/acmetool"
  url "https://github.com/hlandau/acmetool.git",
      :tag      => "v0.2.1",
      :revision => "f68b275d0a0ca526525b1d11e58be9b7e995251f"
  head "https://github.com/hlandau/acmetool.git"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "go" => :build

  conflicts_with "acmetool", :because => "Differing version of same formula"

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    # https://github.com/hlandau/acme/blob/221ea15246f0bbcf254b350bee272d43a1820285/_doc/PACKAGING-PATHS.md
    ldflags = %W[
      -X github.com/hlandau/acmetool/storage.RecommendedPath=#{var}/lib/acmetool
      -X github.com/hlandau/acmetool/hooks.DefaultPath=#{lib}/hooks
      -X github.com/hlandau/acmetool/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
    ]

    inreplace "Makefile" do |s|
      s.sub! /-ldflags "(.*)"/, '\1'
      s.sub! /(\$\(call BUILDINFO.*\)\))/, '-ldflags "$(LDFLAGS) \1"'
      s.sub! /(install) -Dp/, '\1 -d $(DESTDIR)$(PREFIX)/bin && \1 -p'
      s.sub! /(go install.* ..BINARIES.)/, 'pushd "src/$(PROJNAME)"; \1; popd'
      s.sub! /(\$\(call .*)#{Regexp.escape "/..."}/, build.head? ? 'pushd "src/$(PROJNAME)"; \1@master; popd' : ""
      s.gsub! "git.devever.net/hlandau/acmetool", "github.com/hlandau/acmetool"
    end

    if build.head?
      (buildpath/"go.mod").write <<~EOS
        module github.com/hlandau/acme
        require github.com/satori/go.uuid v1.2.1-0.20181028125025-b2ce2384e17b
        replace github.com/coreos/go-systemd => github.com/coreos/go-systemd/v22 latest
      EOS
    else
      (buildpath/"go.mod").write <<~EOS
        module github.com/hlandau/acme
        require (
          github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751 // indirect
          github.com/alecthomas/units v0.0.0-20190924025748-f65c72e2690d // indirect
          github.com/btcsuite/winsvc v1.0.0 // indirect
          github.com/coreos/go-systemd v0.0.0-20191104093116-d3cd4ed1dbcf
          github.com/erikdubbelboer/gspt v0.0.0-20190125194910-e68493906b83 // indirect
          github.com/fatih/color v1.9.0 // indirect
          github.com/godbus/dbus v4.1.0+incompatible // indirect
          github.com/google/go-cmp v0.4.1 // indirect
          github.com/hlandau/acmetool v0.2.1
          github.com/hlandau/buildinfo v0.0.0-20161112115716-337a29b54997 // indirect
          github.com/hlandau/dexlogconfig v0.0.0-20161112114350-244f29bd2608
          github.com/hlandau/goutils v0.0.0-20160722130800-0cdb66aea5b8
          github.com/hlandau/xlog v1.0.0
          github.com/jmhodges/clock v0.0.0-20160418191101-880ee4c33548
          github.com/mattn/go-colorable v0.1.6 // indirect
          github.com/mattn/go-isatty v0.0.13-0.20200128103942-cb30d6282491 // indirect
          github.com/mattn/go-runewidth v0.0.9 // indirect
          github.com/mitchellh/go-wordwrap v1.0.0
          github.com/ogier/pflag v0.0.2-0.20160129220114-45c278ab3607 // indirect
          github.com/peterhellberg/link v1.1.0 // indirect
          github.com/satori/go.uuid v1.2.1-0.20181028125025-b2ce2384e17b
          github.com/shiena/ansicolor v0.0.0-20151119151921-a422bbe96644 // indirect
          golang.org/x/crypto v0.0.0-20200602180216-279210d13fed // indirect
          golang.org/x/net v0.0.0-20200602114024-627f9648deb9
          golang.org/x/sys v0.0.0-20200602225109-6fdc65e7d980 // indirect
          golang.org/x/text v0.3.3-0.20200513185708-81608d7e9c68 // indirect
          gopkg.in/alecthomas/kingpin.v2 v2.2.6
          gopkg.in/cheggaaa/pb.v1 v1.0.28
          gopkg.in/hlandau/acmeapi.v2 v2.0.1
          gopkg.in/hlandau/configurable.v1 v1.0.1 // indirect
          gopkg.in/hlandau/easyconfig.v1 v1.0.17
          gopkg.in/hlandau/service.v2 v2.0.16
          gopkg.in/hlandau/svcutils.v1 v1.0.10
          gopkg.in/square/go-jose.v1 v1.1.2
          gopkg.in/square/go-jose.v2 v2.5.1 // indirect
          gopkg.in/tylerb/graceful.v1 v1.2.15
          gopkg.in/yaml.v2 v2.3.0
        )
      EOS
    end

    buildinfo_pkg = "github.com/hlandau/buildinfo"
    (buildpath/"src/#{buildinfo_pkg}").mkpath
    (buildpath/"src/#{buildinfo_pkg}/gen").write <<~EOS
      #!/bin/bash
      BUILDNAME="$(date -u "+%Y%m%d%H%M%S") on $(hostname -f)"
      cd "$GOPATH/src/$1"; while [ ! -f go.mod -a "$PWD" != "$GOPATH" ]; do cd ..; done
      echo -X github.com/hlandau/buildinfo.RawBuildInfo=$( \
        (echo built $BUILDNAME; go list -m all | sed "1d") | base64 | tr -d \'\\n\' \
      )
    EOS
    chmod "+x", buildpath/"src/#{buildinfo_pkg}/gen"

    system "make", "LDFLAGS=#{ldflags.join(" ")}", "PREFIX=#{prefix}", "USE_BUILDINFO=1", "V=1", "install"

    (man8/"acmetool.8").write Utils.popen_read(bin/"acmetool", "--help-man")

    doc.install Dir["doc/*"]
  end

  def post_install
    (var/"lib/acmetool").mkpath
    (var/"run/acmetool").mkpath
  end

  test do
    assert_match Regexp.new(version.to_s.gsub(/.*-/, "acmetool .*-")), shell_output("#{bin}/acmetool --version", 2)
  end
end
