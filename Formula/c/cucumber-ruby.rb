class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/refs/tags/v9.2.1.tar.gz"
  sha256 "d15fec49a75c2e0d740c87b16818a3cacc317f1751d075444cb93a87ddaaf2dc"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "20381cf2c1bbdb4f7ebea8dc4a0a8ed54da15918a5990a4174da415143f1d614"
    sha256 cellar: :any,                 arm64_sonoma:  "998779f5565e45a08537c4ee50623709e0a18b9196566b0e38960a550835e19d"
    sha256 cellar: :any,                 arm64_ventura: "f666102925eaf6f28a901e04718ce7b11a6b212b5ac99facc05976619ead0da1"
    sha256 cellar: :any,                 sonoma:        "a064069552ea70949964106b212ac03a08545a1ff8cf579866157c3f081625f0"
    sha256 cellar: :any,                 ventura:       "4a50724c662c7703e7194415b307960575aa2fcdb9a02aa33af952469fdf807a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "729a70a8e6dfb8478fbd440b3d2c2dc0a90207e2b1e6eb8aea9eb96daf75e2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9d621e6af198167ae28ec80ffd44a87c2cffee29c5bc81869a1dc9c46e8152"
  end

  depends_on "pkgconf" => :build
  depends_on "ruby"

  uses_from_macos "libffi", since: :catalina

  # Runtime dependencies of cucumber
  # List with `gem install --explain cucumber`
  # https://rubygems.org/gems/cucumber/versions/9.0.1/dependencies

  resource "ffi" do
    url "https://rubygems.org/gems/ffi-1.17.1.gem"
    sha256 "26f6b0dbd1101e6ffc09d3ca640b2a21840cc52731ad8a7ded9fb89e5fb0fc39"
  end

  resource "sys-uname" do
    url "https://rubygems.org/gems/sys-uname-1.3.1.gem"
    sha256 "b7b3eb817a9dd4a2f26a8b616a4f150ab1b79f4682d7538ceb992c8b7346f49c"
  end

  resource "multi_test" do
    url "https://rubygems.org/gems/multi_test-1.1.0.gem"
    sha256 "e9e550cdd863fb72becfe344aefdcd4cbd26ebf307847f4a6c039a4082324d10"
  end

  resource "mini_mime" do
    url "https://rubygems.org/gems/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "diff-lcs" do
    url "https://rubygems.org/gems/diff-lcs-1.5.1.gem"
    sha256 "273223dfb40685548436d32b4733aa67351769c7dea621da7d9dd4813e63ddfe"
  end

  resource "cucumber-messages" do
    url "https://rubygems.org/gems/cucumber-messages-22.0.0.gem"
    sha256 "d08a6c228675dd036896bebe82a29750cbdc4dacd461e39edd1199dfa36da719"
  end

  resource "cucumber-html-formatter" do
    url "https://rubygems.org/gems/cucumber-html-formatter-21.7.0.gem"
    sha256 "e116a23dd4827b76f5055e4bcba2899ac5d9391293000486680bf9a14d0bc252"
  end

  resource "cucumber-gherkin" do
    url "https://rubygems.org/gems/cucumber-gherkin-27.0.0.gem"
    sha256 "2e6a8212c1d0107f95d75082e8bd5f05ace4e42dd77a396c7b713be3a8067718"
  end

  resource "bigdecimal" do
    url "https://rubygems.org/gems/bigdecimal-3.1.5.gem"
    sha256 "534faee5ae3b4a0a6369fe56cd944e907bf862a9209544a9e55f550592c22fac"
  end

  resource "cucumber-cucumber-expressions" do
    url "https://rubygems.org/gems/cucumber-cucumber-expressions-17.1.0.gem"
    sha256 "a1be9df1e5d787f62ff89e5a96c9a78e2e3b989cef7bf698f22cd5efd699d391"
  end

  resource "cucumber-tag-expressions" do
    url "https://rubygems.org/gems/cucumber-tag-expressions-6.1.1.gem"
    sha256 "ccf1bb8ae92dc5f91571b3e8f034b496b079e2e25cabb802dd64b24975483430"
  end

  resource "cucumber-core" do
    url "https://rubygems.org/gems/cucumber-core-13.0.3.gem"
    sha256 "e01c28d658dc0a8d5804507e0b63b58ba0e4fbe8e7d50f8f19c17b44872c5344"
  end

  resource "cucumber-ci-environment" do
    url "https://rubygems.org/gems/cucumber-ci-environment-10.0.1.gem"
    sha256 "bb6e3fcec85c981dff4561997e8675a7123eead5fe9e587d2ad7568adbe18631"
  end

  resource "builder" do
    url "https://rubygems.org/gems/builder-3.3.0.gem"
    sha256 "497918d2f9dca528fdca4b88d84e4ef4387256d984b8154e9d5d3fe5a9c8835f"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      args = ["--ignore-dependencies", "--no-document", "--install-dir", libexec]
      # Fix segmentation fault on Apple Silicon
      # Ref: https://github.com/ffi/ffi/issues/864#issuecomment-875242776
      args += ["--", "--enable-libffi-alloc"] if r.name == "ffi" && OS.mac? && Hardware::CPU.arm?
      system "gem", "install", r.cached_download, *args
    end
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "--ignore-dependencies", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_path_exists testpath/"features"
  end
end
