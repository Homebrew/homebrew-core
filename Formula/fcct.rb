class Fcct < Formula
  desc "Fedora CoreOS Config Transpiler"
  homepage "https://github.com/coreos/fcct"
  url "https://github.com/coreos/fcct/archive/v0.9.0.tar.gz"
  sha256 "1d937294bf82512b0b030421c49a837529f5b3c116ed480543d8c9663c488388"
  license "Apache-2.0"
  head "https://github.com/coreos/fcct.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "365386878665e279e3649861a1e7955dd28898ed3eec6b1c3b144339fbb397bf" => :big_sur
    sha256 "423e25428e2aa6c037c573c5a9d158f93d4423306cf5396fcdd0e3d0298e0526" => :arm64_big_sur
    sha256 "6db04a1c576680f2b5a1789b0f9df88f2215bc668e9e20fd19410183b340e734" => :catalina
    sha256 "513e72c532404b4458605cd6d37922d427b68eaebdc50f85ccfafedc65cd480c" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor",
      "-ldflags", "-w -X github.com/coreos/fcct/internal/version.Raw=#{version}",
      *std_go_args, "internal/main.go"

    prefix.install_metafiles
  end

  test do
    (testpath/"example.fcc").write <<~EOS
      variant: fcos
      version: 1.1.0
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
    EOS

    (testpath/"broken.fcc").write <<~EOS
      variant: fcos
      version: 1.1.0
      passwd:
        users:
          - name: core
            broken_authorized_keys:
              - ssh-rsa mykey
    EOS

    system "#{bin}/fcct", "--strict", "--output=#{testpath}/example.ign", "#{testpath}/example.fcc"
    assert_predicate testpath/"example.ign", :exist?
    assert_match /.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip

    output = shell_output("#{bin}/fcct --strict #{testpath}/example.fcc")
    assert_match /.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip

    shell_output("#{bin}/fcct --strict --output=#{testpath}/broken.ign #{testpath}/broken.fcc", 1)
    refute_predicate testpath/"broken.ign", :exist?

    assert_match version.to_s, shell_output("#{bin}/fcct --version 2>&1")
  end
end
