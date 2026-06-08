class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://github.com/pamburus/hl/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "4b369b05f339b3cabb1c83a591fb6456966cb3d4197a5e1c75ed408e8aaed9e2"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1669cd48926b1ca8bcfc03c3be2fc3e8955f61401b43c0e375e4f6cc3a9f4d08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7063c193e091d31e0c918c3d8648540eb14da0c3d179322a463c50311d136a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2f00404f2d92a885b87580bcc0d1984e2f7788d0ead71851a21077342a78729"
    sha256 cellar: :any_skip_relocation, sonoma:        "27be1863d8d97cf1082825d36c193996f9c7662dfb00e271ed2aa8a9c926cd93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66540d776e2cdbe99c5963bfce1807aa69f438d789c46cb63a0aaf1161fb3b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c8ad9ccd7745068dd96794ec53dda36e5c9ddca0a9498c853ba6b1105ebf93e"
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
      time="2026-02-28 12:00:00" level=INFO msg="Starting process"
      time="2026-02-28 12:01:00" level=ERROR msg="An error occurred"
      time="2026-02-28 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}/hl --level ERROR sample.log")
    assert_equal "2026-02-28 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end
