class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://github.com/lgarron/folderify/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "4fbf770168a540dd39ea07d8c5670a065d54c6f458f113af748e0f1d9cc1e538"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f568abdc99247b1f104cc10ae711e9770b14b6dbe5fc7ca4594e4fb12ecf501f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bdb07ccc35e7209d53f814db5399ec83d054edd9e452200c3e7a79903613986d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f55b2f56f04b8eebebe263748a5c64ca5f5c132d025b099b6cc83195c26d84db"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"
  depends_on :macos

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
