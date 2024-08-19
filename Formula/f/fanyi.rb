class Fanyi < Formula
  desc "Chinese and English translate tool in your command-line"
  homepage "https://github.com/afc163/fanyi"
  url "https://registry.npmjs.org/fanyi/-/fanyi-8.0.3.tgz"
  sha256 "5798b84e26584878024fa5038defe3d1a33d5d600c95290b6c54d1dd8cdef421"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "492499711ec5231ee325e0545e3ac88fe3807846ada190ddd0fa403e192c93bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "492499711ec5231ee325e0545e3ac88fe3807846ada190ddd0fa403e192c93bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492499711ec5231ee325e0545e3ac88fe3807846ada190ddd0fa403e192c93bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b6e640b0079f8b9dbbfe64a76022d1fcf5785b8f5202fcc0d534034ab27bd04"
    sha256 cellar: :any_skip_relocation, ventura:        "6b6e640b0079f8b9dbbfe64a76022d1fcf5785b8f5202fcc0d534034ab27bd04"
    sha256 cellar: :any_skip_relocation, monterey:       "6b6e640b0079f8b9dbbfe64a76022d1fcf5785b8f5202fcc0d534034ab27bd04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069d7deffbebdf7583a77d75eeb2299a484cf07d5ef759a52414e71e42856fe7"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    term_size_vendor_dir = libexec/"lib/node_modules"/name/"node_modules/term-size/vendor"
    rm_r(term_size_vendor_dir) # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
  end

  test do
    assert_match "爱", shell_output("#{bin}/fanyi --no-say love 2>/dev/null")
  end
end
