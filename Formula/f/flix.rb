class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://github.com/flix/flix/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "be8578985461aca9bcd56c78e933821aa1849deb77974c7851a75bc659b9015f"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcfbe9a21adf53cf8111ed28004bb2659567f38e86efd24d84348f5ebbd9a12d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5e68c21fcec6284b4c0a895d630fc4a4fd6b02b246cec1b6d0184108648c3d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c58c07f1358841dd99e0201052a768dcdb1c3a2726f945d2ea433b055261ad9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cbf7eb79137ab6e425381ae4b2031bcf2e849d47e8d2ed2703264fd4abff57f"
    sha256 cellar: :any_skip_relocation, ventura:       "c9d5dfd2b4652688d946783f342aa1d25fac2755a15dad57770a9497accea3c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50b604765d3d75774d1252bea6c0d144c1e6cf3436dff36d414992092f86a2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54504ea2a1355a02d0a06307a5f23667df8748180afa02a961f8a2e7a84529c9"
  end

  depends_on "gradle" => :build
  depends_on "scala" => :build
  depends_on "openjdk@21"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("21")
    system Formula["gradle"].bin/"gradle", "--no-daemon", "build", "jar"
    prefix.install "build/libs/flix-#{version}.jar"
    bin.write_jar_script prefix/"flix-#{version}.jar", "flix", java_version: "21"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end
