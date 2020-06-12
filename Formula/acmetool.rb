class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  revision 1
  url "https://github.com/hlandau/acme.git",
      :tag      => "v0.0.67",
      :revision => "221ea15246f0bbcf254b350bee272d43a1820285"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "859ddcc717399c6724283beece51c0a93497e00be685d3f1cfb7153506cbd9bb" => :catalina
    sha256 "fd6d5e67865a1038fef6f4b183c255e42e4eb6470d5847e804639197f226da6b" => :mojave
    sha256 "62ec2c87880494488a50d78c36104f75eb97bb160ddf316387ab116e51ace2fd" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "acmetool@0.2", :because => "Differing version of same formula"

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    # https://github.com/hlandau/acme/blob/221ea15246f0bbcf254b350bee272d43a1820285/_doc/PACKAGING-PATHS.md
    ldflags = %W[
      -X github.com/hlandau/acme/storage.RecommendedPath=#{var}/lib/acmetool
      -X github.com/hlandau/acme/hooks.DefaultPath=#{lib}/hooks
      -X github.com/hlandau/acme/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
    ]

    inreplace "Makefile" do |s|
      s.sub! /-ldflags "(.*)"/, '\1'
      s.sub! /(\$\(call BUILDINFO.*\)\))/, '-ldflags "$(LDFLAGS) \1"'
      s.sub! /(install) -Dp/, '\1 -d $(DESTDIR)$(PREFIX)/bin && \1 -p'
      s.sub! /(go install.* ..BINARIES.)/, 'pushd "src/$(PROJNAME)"; \1; popd'
      s.sub! /\$\(call .*#{Regexp.escape "/..."}/, ""
    end

    (buildpath/"go.mod").write <<~EOS
      module github.com/hlandau/acme
      require (
        github.com/BurntSushi/toml v0.3.1 // indirect
        github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc // indirect
        github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf // indirect
        github.com/btcsuite/winsvc v1.0.0 // indirect
        github.com/coreos/go-systemd v0.0.0-20180108085132-cc4f39464dc7 // indirect
        github.com/erikdubbelboer/gspt v0.0.0-20190125194910-e68493906b83 // indirect
        github.com/hlandau/acmetool v0.0.67 // indirect
        github.com/hlandau/dexlogconfig v0.0.0-20161112114350-244f29bd2608
        github.com/hlandau/goutils v0.0.0-20160722130800-0cdb66aea5b8
        github.com/hlandau/xlog v1.0.0
        github.com/jmhodges/clock v0.0.0-20160418191101-880ee4c33548
        github.com/mattn/go-isatty v0.0.4 // indirect
        github.com/mattn/go-runewidth v0.0.3-0.20170510074858-97311d9f7767 // indirect
        github.com/mitchellh/go-wordwrap v0.0.0-20150314170334-ad45545899c7
        github.com/ogier/pflag v0.0.2-0.20160129220114-45c278ab3607 // indirect
        github.com/peterhellberg/link v1.0.1-0.20171231092049-8768c6d4dc56
        github.com/satori/go.uuid v1.2.1-0.20180103174451-36e9d2ebbde5
        github.com/shiena/ansicolor v0.0.0-20151119151921-a422bbe96644 // indirect
        golang.org/x/crypto v0.0.0-20180119165957-a66000089151
        golang.org/x/net v0.0.0-20180112015858-5ccada7d0a7b
        golang.org/x/sys v0.0.0-20180117170059-2c42eef0765b // indirect
        golang.org/x/text v0.3.1-0.20171227012246-e19ae1496984 // indirect
        gopkg.in/alecthomas/kingpin.v2 v2.2.6
        gopkg.in/cheggaaa/pb.v1 v1.0.20
        gopkg.in/hlandau/configurable.v1 v1.0.1 // indirect
        gopkg.in/hlandau/easyconfig.v1 v1.0.16
        gopkg.in/hlandau/service.v2 v2.0.16
        gopkg.in/hlandau/svcutils.v1 v1.0.10
        gopkg.in/square/go-jose.v1 v1.1.0
        gopkg.in/tylerb/graceful.v1 v1.2.15
        gopkg.in/yaml.v2 v2.0.0
      )
    EOS

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

  def caveats
    <<~EOS
      As of June 2020, subscribers to the Let's Encrypt service are no longer allowed
      to validate new domains through the ACMEv1 protocol, and renewal of existing
      certificates will occasionally be disabled starting early 2021, before the final
      EoL of ACMEv1 by June 2021.

      New users should therefore use \x1B[3m\x1B[1macmetool@0.2\x1B[0m to obtain certificates via ACMEv2
      unless they intend to import existing accounts from another tool. Current users
      should also consider upgrading to ACMEv2, though this has to be done manually
      for the time being. Please follow \x1B[4mhttps://github.com/hlandau/acmetool/issues/322\x1B[0m
      for upgrade instructions and discussion on the future of acmetool.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acmetool --version", 2)
  end
end
