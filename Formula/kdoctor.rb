class Kdoctor < Formula
  desc "Environment diagnostics for Kotlin Multiplatform Mobile app development"
  homepage "https://github.com/kotlin/kdoctor"
  url "https://github.com/Kotlin/kdoctor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6c65a454ddb0258122f8dc4ab0cce5dff21425da770a07685eada13f78c8df65"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kdoctor.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "095b49bdacbc9e40c7da081533f87e54aa7053cc897a2a7a16690d9edbf5726f"
    sha256 cellar: :any, arm64_monterey: "e02293c5e22037d46c7aa5381f2f7ec7cc09f0de971e4b95100acaa3bcd4f8cc"
    sha256 cellar: :any, arm64_big_sur:  "c5dd4c19bb59df578963e1b60b8bc427b66e9b6f0f49a249ffc0a2209e50960e"
    sha256 cellar: :any, ventura:        "eed0101170752ca261c184ade26a6cc83db1d2839b603517602d2685ae406b51"
    sha256 cellar: :any, monterey:       "eed0101170752ca261c184ade26a6cc83db1d2839b603517602d2685ae406b51"
    sha256 cellar: :any, big_sur:        "f1a4c78c51bbce87f4e03ff0c63280e5850afda7008ebb9dcb919858b53103a4"
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
