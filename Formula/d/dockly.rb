class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.24.5.tgz"
  sha256 "278203ca5fe88f802f50a9fe58f37e95309ccb098b47a6f5f3558ccc9dc623b6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e276939bcb8b5909e0c6ab1d39a740b724de614668235b8c3606d57e67d41e64"
    sha256                               arm64_sequoia: "6765be9e2eb88427da832627e84bfc14e832546ec895c4f3a80e618521a29bbb"
    sha256                               arm64_sonoma:  "21d9206c6dd01067b8ab10a86bbce37c1c1b33c1fa8f06aaed4ab4b3e2d11f79"
    sha256                               arm64_ventura: "edba097b50de91a673b9504054ec42ed435cbd6766985af57a90b4de005900c8"
    sha256                               sonoma:        "b6075b00e725da80c041f56a98977e4c74059eaec6486d26d628e5288157301a"
    sha256                               ventura:       "fa994bb066eb8c0190c2c7cfa674255fe9de6491a4a182d75697f2eed99dd435"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961cd52469f0445138bda46c29f8466f7d7f2e0587af77d2f0981a9d30e253a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f10763b5b89d92dd010032e24ac0e060df6bb12f44118dec3ee2e0c28938d55a"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    expected = if OS.mac?
      "Error: connect ENOENT"
    else
      "Error: connect EACCES"
    end
    assert_match expected, shell_output("#{bin}/dockly 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/dockly --version")
  end
end
