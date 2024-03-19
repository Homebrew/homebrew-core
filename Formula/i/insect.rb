require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.9.0.tgz"
  sha256 "dcb8d696e9209157f596c7c102cdc436d520629d2aed71585767af77bde2cb70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18eb304364ec3dd645ab650432808b5c763ae2df8d06f43e274f8b5109674215"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7845c3b40dcbeb93032afe4eef3839e48a6f659770d0c19b5b38173e53b83c09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7845c3b40dcbeb93032afe4eef3839e48a6f659770d0c19b5b38173e53b83c09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7845c3b40dcbeb93032afe4eef3839e48a6f659770d0c19b5b38173e53b83c09"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc0cf1f74fd50e7ea3a781f70aaffaaa09d7185749be28e2a182a8ba193cf1ac"
    sha256 cellar: :any_skip_relocation, ventura:        "b1c71d93eb2243de16f515679f49c65ee21997a8de9d73a6c1787391860c786c"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c71d93eb2243de16f515679f49c65ee21997a8de9d73a6c1787391860c786c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1c71d93eb2243de16f515679f49c65ee21997a8de9d73a6c1787391860c786c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5846fc2affc562455f3c03862eb02975249bb294658e1cf0269dc93fb0c09e"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_equal "120000 ms", shell_output("#{bin}/insect '1 min + 60 s -> ms'").chomp
    assert_equal "299792458 m/s", shell_output("#{bin}/insect speedOfLight").chomp
  end
end
