class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.58.tar.gz"
  sha256 "c82a52a2ff76c2a7e184268ae961bae398fa97012d46ab8dad092f21e2fa8752"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3170bec5e29e4aa9037952afd01517d85fc9ec217d80e109bcd4bc1bd9f4692"
    sha256 cellar: :any,                 arm64_sonoma:  "1c26f3603c1b1d8d5951631240ea826f2256d7e9d7d03f3373c81c458c3f9546"
    sha256 cellar: :any,                 arm64_ventura: "5f69d4e24aa3c4899df7800a264427150a0effb5e4cbd62bca9b4cacd58dfade"
    sha256 cellar: :any,                 sonoma:        "b64d98c5631d8f3bf59e308861d63f955d8737521131704e475269b237ccdc28"
    sha256 cellar: :any,                 ventura:       "08ba0765eb24fd5a0219e415a5fc794f30a7efa901e2a88f9808481ac199ea8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dac47d6094557b5e505b99b40321e9b4c5572503bc1ba9b76e6b930ea56c340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5422bb32ab7aaaf248af272af66f297e91c9c81bac139a47f69dd201a48dc10a"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~MARKDOWN
      # title first level
      ## title second level
    MARKDOWN
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
