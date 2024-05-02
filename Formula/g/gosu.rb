class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.17.9.tar.gz"
  sha256 "cd638f2f2091758a85085f39ad175c657b4a1cafbdf416893667daa0a975243e"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba6790b14a3283dfc1aa31090ac467bd77ec25ee62266480658ffc4d908f191f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32d384b63f35c827a98f084497262830cf6c7a113dce7f489f452efc9ef2ed92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be6e12aea72673cda15dd1cf44e53866b2623c77d4d91376c63899d0daeffd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f26a91dfd734e8195e71b6fad497fa96af4e6cf6f6dfca4697ccf4cbf82fe5e"
    sha256 cellar: :any_skip_relocation, ventura:        "315fdd6c5f146c4fc0b62c351e3bc6885eca2558d23fa687cec07fc003ef3e00"
    sha256 cellar: :any_skip_relocation, monterey:       "4d71f14d2ecec1de756ab20c446794254d98647bdc7cf893cdec1f4f4fb2b419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "461856b862c0da0ddd12784b6e040e62a7a31a80f6544625e422719e00e5200f"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  skip_clean "libexec/ext"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("11")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
