class Archiver < Formula
  desc "Cross-platform, multi-format archive utility"
  homepage "https://github.com/mholt/archiver"
  url "https://github.com/mholt/archiver/archive/v3.5.1.tar.gz"
  sha256 "b69a76f837b6cc1c34c72ace16670360577b123ccc17872a95af07178e69fbe7"
  license "MIT"
  head "https://github.com/mholt/archiver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9194e883ec240998c4c2ec26a4cc8d79d1ad29964b592ac0cc45c9b6c5da7dd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a4c576219a90d52a24dec089f2ef3cd900f5d9779d57fc6f6d83c8e2ae7241c"
    sha256 cellar: :any_skip_relocation, monterey:       "f0c4b8adac0f867744ccde72ed8d83f66bcf098f45e32edf7c1dfd347772ee9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "74fd6ad65f0b92af3a034874d6317065b7805d98cb945006d05dff0117d179d6"
    sha256 cellar: :any_skip_relocation, catalina:       "b2a0192ed66099721b7662fe5d772f8a99ecb5c8922270cbc825cdcbb7032378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461a212b25cc90af84996b43067bbd096cf343bbe04a39b4aa40d10cb235e238"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"arc", "cmd/arc/main.go"
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
