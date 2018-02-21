class NodeAT4 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v4.8.7/node-v4.8.7.tar.xz"
  sha256 "03479a8ce6affedde75d80a6c8c351a7afb5a85b8d7e5119ab6f349100e641f8"
  head "https://github.com/nodejs/node.git", :branch => "v4.x-staging"

  bottle do
    rebuild 1
    sha256 "7809a0930e7ea37c92cc3640546d36e24d8173163562dc75185e4ba7addf591b" => :high_sierra
    sha256 "f0fe0a4bdf8d99110335b963f0fd91db8a8a364e387932f91a0b37482b99403d" => :sierra
    sha256 "bfa9ffd67fd999fbfb2d6e8687e00b8c706531b197d608d119cf04e8be62917f" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-debug", "Build with debugger hooks"
  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "with-full-icu", "Build with full-icu (all locales) instead of small-icu (English only)"

  depends_on "python" => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "openssl" => :optional

  # Keep in sync with main node formula
  resource "npm" do
    url "https://registry.npmjs.org/npm/-/npm-5.6.0.tgz"
    sha256 "b1f0de3767136c1d7b4b0f10e6eb2fb3397e2fe11e4c9cddcd0030ad1af9eddd"
  end

  resource "icu4c" do
    url "https://ssl.icu-project.org/files/icu4c/58.2/icu4c-58_2-src.tgz"
    mirror "https://fossies.org/linux/misc/icu4c-58_2-src.tgz"
    version "58.2"
    sha256 "2b0a4410153a9b20de0e20c7d8b66049a72aef244b53683d0d7521371683da0c"
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-npm" if build.without? "npm"
    args << "--debug" if build.with? "debug"
    args << "--shared-openssl" if build.with? "openssl"

    if build.with? "full-icu"
      args << "--with-intl=full-icu"
    else
      args << "--with-intl=small-icu"
    end
    args << "--tag=head" if build.head?

    resource("icu4c").stage buildpath/"deps/icu"

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    if build.without? "npm"
      <<~EOS
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert_predicate bin/"npm", :exist?, "npm must exist"
      assert_predicate bin/"npm", :executable?, "npm must be executable"
      npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
      system "#{bin}/npm", *npm_args, "install", "npm@latest"
      system "#{bin}/npm", *npm_args, "install", "bignum" unless head?
    end
  end
end
