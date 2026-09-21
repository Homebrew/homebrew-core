class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "3a50b66b888754047931969d9a1fb84178406b638c183a387a58deb48529776a"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e94c8c76a451c60a585e7d10f6fa289414a5ec6602be00ca487518c4088b0a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5f005c6bae4577bef91af480ebf13e9affb7d8de0729c126fb709d43a1cb906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "550adbb3866da306194a7a90b8fdecfe612263ab4dd909e9941d1f0de2c256d5"
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

    # Stop at the iconset: `iconutil` needs LaunchServices, which the sandbox denies
    system bin/"folderify", "test.svg", "--output-iconset", testpath/"test.iconset", "--no-progress"
    assert_predicate testpath/"test.iconset/icon_512x512.png", :size?
  end
end
