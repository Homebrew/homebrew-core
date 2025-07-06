class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archives"
  url "https://github.com/mholt/archives/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "3f70d4e8f083c68904a48ff2262f74c595014de96bf5e7e995bdc4a53b747f13"
  license "MIT"
  head "https://github.com/mholt/archives.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"arc"), "./cmd/arc"
  end

  test do
    output = shell_output("#{bin}/arc --help 2>&1")
    assert_match "Usage: arc {archive|unarchive", output

    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Moien!"

    system bin/"arc", "archive", "test.zip",
           "test1", "test2", "test3"

    assert_path_exists testpath/"test.zip"
    assert_match "Zip archive data",
                 shell_output("file -b #{testpath}/test.zip")

    output = shell_output("#{bin}/arc ls test.zip")
    names = output.lines.map do |line|
      columns = line.split(/\s+/)
      File.basename(columns.last)
    end
    assert_match "test1 test2 test3", names.join(" ")
  end
end
