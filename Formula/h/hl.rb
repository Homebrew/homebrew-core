class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "1e00a7e1e393c3362d7a3b7c22481cb93378d1c93ff00f79afb618b203e817ab"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b0fc5376f9f5be393106aca72d29e59ee67637e2a3f7e81a6a6f920f0eedd67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d4f927601691540ddda15e7d14a0aa2bef3801a7d8fda91675902b3cf9bed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb4c07cb6f06387135263b2b9c8436b6bc22583b8c16fbd1fdcde2ad1dcc320"
    sha256 cellar: :any_skip_relocation, sonoma:        "3389b9d4eb6e66d32c6187f7dfe807dce740f0a9d0ce0408e4c9e6ce0c0a31b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f2d9ed3c29ca35f608a51015d8707ec811e04d0ee26dcd4832f48622f6e3e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81b1bc7eadf5f16b814adcdc4fba488dd8c79693dcebff59b4d8b449f519cf0"
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
