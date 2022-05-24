class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v7.1.0.tar.gz"
  sha256 "8eafa529f1c8793de09b550b68067af1f3d1b05e8eca798f5755d05ee0aacf8c"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               monterey:     "baa01f4500a6ddda6ce2260f20482e9d0f2bfc9ab55f52bf373f06566c1b94d4"
    sha256                               big_sur:      "8da8aa2314fef7577cfdbd3b580303d06dd26883f4242de6e5158707eacae4f0"
    sha256 cellar: :any,                 catalina:     "8e10228d88f7a1bf07335a9c54d83872acd107f29c341cd854bc7631d7271662"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c651216b9c2ca701d3e32c08facfc3851e3b8f18d5f4779464424e9eff6b4797"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :big_sur

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_predicate testpath/"features", :exist?
  end
end
