class Abcl < Formula
  desc "Armed Bear Common Lisp: a full implementation of Common Lisp"
  homepage "https://abcl.org/"
  url "https://abcl.org/releases/1.9.1/abcl-src-1.9.1.tar.gz"
  sha256 "a5bc677c9441f4a833c20a541bddd16fff9264846691de9a1daf6699f8ff11e2"
  license "GPL-2.0-or-later" => {
    with: "Classpath-exception-2.0",
  }
  head "https://abcl.org/svn/trunk/abcl/", using: :svn

  livecheck do
    url :homepage
    regex(/href=.*?abcl-src[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43fa93bc3b6c4c4c136732ac289ed8bca4d44914f93912ff4c285ecef37e2095"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8e53e35ea6af86e5b865a93d578ee26bee5610f9cf97daac24e288540cb756c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed8bbb699fdadf8f25b9eb569ee4a2daf911d6351ab0a880bed6416d63a9623a"
    sha256 cellar: :any_skip_relocation, ventura:        "5b88c2e62720de946087f6ba6eaa8f1357f95f4b9439142371d43b30fdd45b2d"
    sha256 cellar: :any_skip_relocation, monterey:       "1133be0f721d6787912d47f886e2197a314ae1e97774bed899064c83e9d33539"
    sha256 cellar: :any_skip_relocation, big_sur:        "b82eecc2658e0cd57d5e601b9569dc77ac1f1417d0e3656af24aa75b08be71bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb66cbe224de377d45b2b89c5342dd74ee18a13cf370258963100e902d64b035"
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
