class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.24.3.tgz"
  sha256 "3c1890a0ae136a36e9c8fabb343db35e4239a172fb284a77d3485a6bab939479"
  license "MIT"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia:  "0dd40f2f0850ba036bdc93a1fc471b0ed3e4c1f8ed443245c01486a3e3f43839"
    sha256                               arm64_sonoma:   "ee7e39240a8e4017526ecb770228cc52bf30e022bff0342cf914ddf8962d6a01"
    sha256                               arm64_ventura:  "c9c59d9621bf60c835ee39a326dfe2139cca675ff1bef2e4d8d78b2bc126fd6e"
    sha256                               arm64_monterey: "453c7bcc52e314d2e1af4b261cf3e109174b4fb59786b64267e015c4cfda0aed"
    sha256                               sonoma:         "4b33d715efe6a38e9d4340e2511f289ab422d4ae7cab70b6c05880fca76f9857"
    sha256                               ventura:        "7be2fcbcaf3b00eb2881b215dc3afff9f6426ee7b9b9d1a0c8f55f8374596f33"
    sha256                               monterey:       "70ac7382b4faaa4a13abb067225aa06a9140309e29f0a0c0bd0b8acd50178a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfb3be9c9648d45b2b73cc768da86ef8470c3144acf6df65e164f0a3eb8c2567"
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
