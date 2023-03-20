class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.17.0.tar.gz"
  sha256 "ea2526362f2c597766ce0346cf13915cf77c5415d0f5fc522ee600afda4a24c3"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42ad89548fd6fe0e4573af11e7e1ee681f931c986eb7ceee5b521a559017560c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a317b30193f679588c7e78cf6d804d6c9ab634206049f444364d0aa8796fcc57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb0381c9e91bc3f4dea05aa35c065898190607ff1bdfc7150139d078b8807e77"
    sha256 cellar: :any_skip_relocation, ventura:        "e06e08e7727166152e5ba585939c9ad03ecc9b2dafee9fed186bc6deafc7de87"
    sha256 cellar: :any_skip_relocation, monterey:       "309e039c38a5919c57882bf1e1c46dc883e23c2ff359aff97d52b1f8aee2ef26"
    sha256 cellar: :any_skip_relocation, big_sur:        "172e0018faa507b7047496ab452a7a181c3e6760be65ae0a09ab0dca5c6c3bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99b7eb0ce501392df82b17c0b4806eebe9f88d27d70f635181a1c5c3907511f2"
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
