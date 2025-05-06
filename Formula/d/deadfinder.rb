class Deadfinder < Formula
  desc "Finds broken links"
  homepage "https://rubygems.org/gems/deadfinder"
  url "https://github.com/hahwul/deadfinder/archive/refs/tags/1.7.1.tar.gz"
  sha256 "fa9f8843b3c793a21b8c3c4c9623f15691c7ef94b8ce9d174d4b8cac7c13b8bd"
  license "MIT"
  head "https://github.com/hahwul/deadfinder.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13018df0825a8907536fd51b444abffff1a403cb75a66541784068e344380294"
    sha256 cellar: :any,                 arm64_sonoma:  "9aa9af3b905a49df8df5198a2c33af78c40d4dbe27172603ddf1cd6e13a968a0"
    sha256 cellar: :any,                 arm64_ventura: "ee48dded63f24b5db5eeb0b4e987f25873bb02a153b03421f799a0156431ca8f"
    sha256 cellar: :any,                 sonoma:        "52e2c68ca58d7333c8a18dc1b98c6559d0b473df83f719b6a433ca47110888ba"
    sha256 cellar: :any,                 ventura:       "218b0148f9ae522dd3ce3690921aafc420563ddb99681b32c231f2a0e63a2835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2b9b260c9b5e8c7e0618087c8e232513b46af93a5ffb9162a7b8e5a3097280a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f03ee2a1dd8fc7872d43948f024a6096fa5957e02d4f29655f9e3a0adc3289"
  end

  depends_on "ruby"

  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove mkmf.log files to avoid shims references
    rm Dir["#{libexec}/extensions/*/*/*/mkmf.log"]
  end

  test do
    assert_match version.to_s, shell_output(bin/"deadfinder version")

    assert_match "Task completed", shell_output(bin/"deadfinder url https://brew.sh")
  end
end
