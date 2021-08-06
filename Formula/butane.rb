class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/v0.13.1.tar.gz"
  sha256 "b71a6cdb54fcacbf78adc06cc291958c228e5a9c8de3cacf04cebc0925ae37ab"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01b950bf19e7a641e36c582e375d97330ff86f7807896fa0747dea34f048740a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c37098f716920c611cb6fe1563a5e68b5db4db8db4ea4969718d3f8a590f0ef2"
    sha256 cellar: :any_skip_relocation, catalina:      "a45fa205eb69ef31e27dfaacd10595e9c4e81792206ad8e14c5af38d1a7aac46"
    sha256 cellar: :any_skip_relocation, mojave:        "4eaa42f7da213f2243506d00259cc40a49e1b6795fa17b90a24426f1b566946d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa4a3d814252c992f15225f24c4ccdb28517cf1c6e9a9d91c68111223958436"
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
