class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/v3.3.2.tar.gz"
  sha256 "1d1db34177fa0d85aea6860b33e94700b1acaa2f3ea626e1f457fede6991041b"
  license "MIT"
  head "https://github.com/mholt/archiver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "320b32ca5ba8f10018a85497d4b68d9a352a4e80a14bed2dd2b48b0917f83187" => :catalina
    sha256 "7c55b6691f89bda40639ce4c39324b1f25172a55422c63b3f320eac84581c3d7" => :mojave
    sha256 "59e44c7523e746cb1a4af375b0e98b30baa65b6909d65b35d116ab9b87e26eea" => :high_sierra
  end

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
