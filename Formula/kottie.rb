class Kottie < Formula
  desc "A cli tool based on Koltin/Native to convert your Lottie JSON to dotLottie format."
  homepage "https://github.com/iamwent/kottie"
  url "https://github.com/iamwent/kottie/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "51cecb0c25e2325c8863049502eef0efdaa39ef6d96e2226d95168a2b6a40818"
  license "Apache-2.0"
  head "https://github.com/iamwent/kottie.git", branch: "main"

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
  depends_on "curl"
  depends_on :macos

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    mac_suffix = Hardware::CPU.intel? ? "X64" : Hardware::CPU.arch.to_s.capitalize
    build_task = "linkReleaseExecutableMacos#{mac_suffix}"
    system "gradle", "clean", build_task
    bin.install "build/bin/macos#{mac_suffix}/releaseExecutable/kottie.kexe" => "kottie"
  end

  test do
    # output = shell_output(bin/"kottie")
    output = shell_output("#{bin}/kottie")
    assert_match "Find lottie files...", output
  end
end
