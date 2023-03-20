class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6c65a454ddb0258122f8dc4ab0cce5dff21425da770a07685eada13f78c8df65"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eba7ca9905740f040831ef93f51aa0ff89df1de0f0505e212705ae913fbcd9fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82601392dd0af59e203244553d423b07621bd310bd63adae4134686259138385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f1cb7722c1bcf843f2648903fb7f7a8832437e0ee6b038312be067f1a50afdc"
    sha256 cellar: :any_skip_relocation, ventura:        "2384ae968cbd575c65c0d9ea152ed83da0712796bb90256671dae8a1e0b349de"
    sha256 cellar: :any_skip_relocation, monterey:       "2384ae968cbd575c65c0d9ea152ed83da0712796bb90256671dae8a1e0b349de"
    sha256 cellar: :any_skip_relocation, big_sur:        "731d3da8ed8c1497b5b305031560f545890930f37b53c36e816a1e0fc3f0ac2d"
  end

  depends_on "gradle" => :build
  depends_on "openjdk" => :build
  depends_on xcode: ["12.5", :build]
  depends_on :macos

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableMacos#{mac_suffix}"
    system "gradle", "clean", build_task
    bin.install "kdoctor/build/bin/macos#{mac_suffix}/releaseExecutable/kdoctor.kexe" => "kdoctor"
  end

  test do
    output = shell_output(bin/"kdoctor")
    assert_match "System", output
    assert_match "Java", output
    assert_match "Android Studio", output
    assert_match "Xcode", output
    assert_match "Cocoapods", output
  end
end
