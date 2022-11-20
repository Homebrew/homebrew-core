class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.51.0.tar.gz"
  sha256 "ce297cada71e1dca33cd7759e55b28518d2bf317cdced1f3b3f79f40fa1958b5"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90378306728d3520372749d0632558adc2ee809652145a720545ffcc80328c92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "530e68bb757c889ad241551f9312b147bb349463c854d72708590dc128798227"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "530e68bb757c889ad241551f9312b147bb349463c854d72708590dc128798227"
    sha256 cellar: :any_skip_relocation, ventura:        "dbedde353648c54dffc593bef54f2a7e089d84bd8756d7913545baf8162cae91"
    sha256 cellar: :any_skip_relocation, monterey:       "0065c059d901a155f99e532ff126ed58abfe27d27b9ab5e3decdf44dcf0ca06d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0065c059d901a155f99e532ff126ed58abfe27d27b9ab5e3decdf44dcf0ca06d"
    sha256 cellar: :any_skip_relocation, catalina:       "0065c059d901a155f99e532ff126ed58abfe27d27b9ab5e3decdf44dcf0ca06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa81693c6c5fe052474ea740a8e49610aea0f2a1fdfd319e9b4333ad17bda82f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
