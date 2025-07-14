class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "145d37b264113f4826fcf2c7e2be3f58ffd0ebcb25031163daef8ee38589219e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdaf5db6b238753ccc890899bc4531755c51e71076fe26d7654973972f4f31e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0031bf440b8167044dd615171095001aad021afb0590e2f179612a0e8bcc9520"
    sha256 cellar: :any_skip_relocation, sonoma:        "e684dc96c078f68dd52cc15e1145789168bd7c4ee3fb4f245a56f3d664d41c6a"
  end

  depends_on xcode: ["15.2", :build]
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/infat"

    generate_completions_from_executable(bin/"infat", "--generate-completion-script")
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end
