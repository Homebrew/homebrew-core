class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/v3.4.0.tar.gz"
  sha256 "00268ce515b3325e41c81c5b2205e5becf3c1480ad86489dd22a4a987f48acf2"
  license "MIT"
  head "https://github.com/mholt/archiver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ad31719ad86f037a53871090741da8448337031bcdb71ea47f2586593bd9b04" => :catalina
    sha256 "963c4901ee5e9bdee50f1a3901012e840bc216b7153fb2d523fde2e7ef5c8686" => :mojave
    sha256 "479af8f187faf342e80725a2bf80296b4a853e2b0a7892a3cd1c90fdbdc0bd56" => :high_sierra
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
