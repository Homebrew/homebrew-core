class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "98bba8014ad46a6c1be97a18064adc67a68d09cf55a13c4b8c1f65c516490d0b"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5821234bc5173cdc2730a11649d5b452d30479fc4c6f7432dc5a2a4b0c8adc06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "675996094b38b68904a661343b205d84aad93630753847d4a2c0998f956f0874"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e350ab70e49aaf3c57173a969c70afc3d768d1bc8dd483d6ee49bfd85e9a3db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5fad8da88d8ee938ee5abc01bee9575e79170708aa00ef40848ac7803e08db0"
    sha256 cellar: :any_skip_relocation, ventura:       "b3d9d7d255cceb974790d468ec01fcf746974927a81f951cf9c6c625b2408489"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "539421f6d4cabd513cc98ecdeeeb6c2fe196ffc5381b9afda8981705560a91ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1509a33864a41b18d451ee729e40fff332fb45075840dad1e8e69ba5c3aab66"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hl", "--shell-completions")
    (man1/"hl.1").write Utils.safe_popen_read(bin/"hl", "--man-page")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hl --version")

    (testpath/"sample.log").write <<~EOS
      time="2025-02-17 12:00:00" level=INFO msg="Starting process"
      time="2025-02-17 12:01:00" level=ERROR msg="An error occurred"
      time="2025-02-17 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}/hl --level ERROR sample.log")
    assert_equal "Feb 17 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end
