class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "e3965b9b5afac55aa82fbeebb66a579d96a7ba98a2663f4f088a786043f234d7"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70cc57334adce376fcab21ddd29f436324a979e918464914683710d068545fb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b251c30a320ac3584fb8344d7fcbbe80ed645b19591999085c507cfefbc7300"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37ca764d90341cc160190e2ab433f0f2594ed56f8420fc92911a55ef879c3022"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3a912f08cf81f1efa8996903598aab99d52b7dc0a32991a1a1f9838f506a675"
    sha256 cellar: :any_skip_relocation, sonoma:        "520ae93a6795588771c02561d8b7820b598aa97e601d308690fd3da10955234e"
    sha256 cellar: :any_skip_relocation, ventura:       "c17c31e13c52554ebbbcabe1c2f7c710f37b5f9e7994173bf1fceb02ab658b25"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    (testpath/"test.svg").write <<~EOS
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
        <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" />
      </svg>
    EOS

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_path_exists testpath/"Icon\r"
  end
end
