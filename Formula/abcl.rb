class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.9.0/abcl-src-1.9.0.tar.gz"
  sha256 "a12b5c84f28834bd988e3adae0ad2ad4cc6c451d9e44f3c0853d007158c19869"
  license "GPL-2.0-or-later" => {
    with: "Classpath-exception-2.0",
  }
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  livecheck do
    url "https://abcl.org/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cec2d54fa4f7c38dbc1a82ab238eaef509d439870cbe304683b70d511e8460f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3be4843794ef45604b332aee04ebd7d9be8170fbfb66c431650f827eb09d603"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a38ec7fe9b6a5ae4dd1f5fe798a6e5d954719fef7748feb70865e1dc900fc8f1"
    sha256 cellar: :any_skip_relocation, ventura:        "3ca09f55767cb920f39c5aafef82e69caff52d69a4f0abac2c64160f619d6961"
    sha256 cellar: :any_skip_relocation, monterey:       "39f244d377cd1ebe59226aa615e77dcfa31b2fff63531646bf1d07bc3c8fb5b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d984b3ec12a62488c75e6888f1dbd9bac15cf78fe5837774095bc295af419c96"
    sha256 cellar: :any_skip_relocation, catalina:       "151786fc05d229cb8cb3f4f2e173c6af3f70635c88f52eb2c4ba05ed0fa53cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "586493f8b333cba0895683381e4d48943bd861aa57c22b13a31b7841f4feb67b"
  end

  depends_on "ant"
  depends_on "openjdk"
  depends_on "rlwrap"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    system "ant", "abcl.properties.autoconfigure.openjdk.8"
    system "ant"

    libexec.install "dist/abcl.jar", "dist/abcl-contrib.jar"
    (bin/"abcl").write_env_script "rlwrap",
                                  "java -cp #{libexec}/abcl.jar:\"$CLASSPATH\" org.armedbear.lisp.Main",
                                  Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"test.lisp").write "(print \"Homebrew\")\n(quit)"
    assert_match(/"Homebrew"$/, shell_output("#{bin}/abcl --load test.lisp").strip)
  end
end
