class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.17.10.tar.gz"
  sha256 "ffe6de4af3d8a4d027714580c10122b883f798dbb98a441461db89413cb59ba2"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb50914898251732401e20f81389594b330377272edc06254696a0cfda03e3ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57abb4b6522a328b4ed38cb5209faea20df27a84cb788afb15954890488b961d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a5e98f4df2b154fbd3f4b9bbf8122a7c4072ae83a4752272ac6c9dc7ee5f469"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1d02c09c06141c2608510cbb7fc83161531d2b68ca50b4b9aaa0b64a4d2db01"
    sha256 cellar: :any_skip_relocation, ventura:        "bd69013bbbe31275e8f2290f0489eee909fbfa3df44a33aacf938a4c6571d1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "fa347227bfc81df647b3f7cc4f006c0122a214b945be5546c9ace0d29ce3a96a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3fd926b0be03407e6177eba8721580e76f9bac1ae55c169b2497d8d23cef350"
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
