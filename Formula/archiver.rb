class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/v3.3.0.tar.gz"
  sha256 "c8e88340e80b428c1a1c9734084395b473c9458fcea8b8b5126a9db96ae45844"
  head "https://github.com/mholt/archiver.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"arc", "cmd/arc/main.go"
  end

  test do
    output = shell_output("#{bin}/arc --help 2>&1")
    assert_match "Usage: arc {archive|unarchive", output

    (testpath/"test1").write "Hello!"
    (testpath/"test2").write "Bonjour!"
    (testpath/"test3").write "Moien!"

    system "#{bin}/arc", "archive", "test.zip",
           "test1", "test2", "test3"

    assert_predicate testpath/"test.zip", :exist?
    assert_match "application/zip",
                 shell_output("file -bI #{testpath}/test.zip")

    output = shell_output("#{bin}/arc ls test.zip")
    names = output.lines.map do |line|
      columns = line.split(/\s+/)
      File.basename(columns.last)
    end
    assert_match "test1 test2 test3", names.join(" ")
  end
end
