class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.12.1.tar.gz"
  sha256 "6f2967009511361ed22cabb1de18ae2a3317537925b3b33b5bfcee363a77d062"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4add137734630309ba525c1f823f91b5b06f86a6d5c1f1b58254bfb21534e91"
    sha256 cellar: :any_skip_relocation, big_sur:       "7ca478b3e3ef5803411e9548a5ca43ebcde9145cca69f97333ad5d7d5b72a423"
    sha256 cellar: :any_skip_relocation, catalina:      "a8eed121c371c702e2b9cd454aa9713fb4620285baa024dcf191d6ce19bd7cec"
    sha256 cellar: :any_skip_relocation, mojave:        "8593c1916fe93e00624d22cbd3699cdd0592fa4d57e846e8badee55a4f257ed5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor",
      *std_go_args(ldflags: "-w -X github.com/coreos/butane/internal/version.Raw=#{version}"), "internal/main.go"
  end

  test do
    (testpath/"example.bu").write <<~EOS
      variant: fcos
      version: 1.3.0
      passwd:
        users:
          - name: core
            ssh_authorized_keys:
              - ssh-rsa mykey
    EOS

    (testpath/"broken.bu").write <<~EOS
      variant: fcos
      version: 1.3.0
      passwd:
        users:
          - name: core
            broken_authorized_keys:
              - ssh-rsa mykey
    EOS

    system "#{bin}/butane", "--strict", "--output=#{testpath}/example.ign", "#{testpath}/example.bu"
    assert_predicate testpath/"example.ign", :exist?
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip)

    output = shell_output("#{bin}/butane --strict #{testpath}/example.bu")
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip)

    shell_output("#{bin}/butane --strict --output=#{testpath}/broken.ign #{testpath}/broken.bu", 1)
    refute_predicate testpath/"broken.ign", :exist?

    assert_match version.to_s, shell_output("#{bin}/butane --version 2>&1")
  end
end
