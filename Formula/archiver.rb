class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/v3.4.0.tar.gz"
  sha256 "00268ce515b3325e41c81c5b2205e5becf3c1480ad86489dd22a4a987f48acf2"
  license "MIT"
  head "https://github.com/mholt/archiver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b21849e81b6a13c0f7929a19670b14bcaa14dc77722435df97b10041c4f38104" => :catalina
    sha256 "fb4bc579b93f20fcc2342ab5cb6e83c97b9e5f13b14c20dd86cd7793f2318865" => :mojave
    sha256 "fb45223dbbcd82d0621c99c317b681f004baf556c69c71c7d4c605c9f14e05ce" => :high_sierra
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
