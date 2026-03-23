class Butane < Formula
  desc "Translates human-readable Butane Configs into machine-readable Ignition Configs"
  homepage "https://github.com/coreos/butane"
  url "https://github.com/coreos/butane/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a13ca441c3b4797e9c78fb7ea8335d889c346e5003f2fa7fb3ffaf6cb6de4c86"
  license "Apache-2.0"
  head "https://github.com/coreos/butane.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea83811b0f1da01a869bbd7bf21371def281c6071e8f14c5153880e1028f9c3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea83811b0f1da01a869bbd7bf21371def281c6071e8f14c5153880e1028f9c3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea83811b0f1da01a869bbd7bf21371def281c6071e8f14c5153880e1028f9c3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "42fc6fed9cec25ba4f5ceed98e19a80ca25d3c9f78d9cf4504185f9f696213ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba7bc463566f368b77da3f77674883b1755ab9b516d69c799a44cf33facdea50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "439452d0ced524b633b6ef611e8496639af192edd26b793f1fe61771c1b68f2c"
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

    system bin/"butane", "--strict", "--output=#{testpath}/example.ign", testpath/"example.bu"
    assert_path_exists testpath/"example.ign"
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, File.read(testpath/"example.ign").strip)

    output = shell_output("#{bin}/butane --strict #{testpath}/example.bu")
    assert_match(/.*"sshAuthorizedKeys":\["ssh-rsa mykey"\].*/m, output.strip)

    shell_output("#{bin}/butane --strict --output=#{testpath}/broken.ign #{testpath}/broken.bu", 1)
    refute_path_exists testpath/"broken.ign"

    assert_match version.to_s, shell_output("#{bin}/butane --version 2>&1")
  end
end
