class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "1cd8149a0992a266eda65d536c95fd8aecd155985e394d9a57f093d0af1fce13"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb7e7c9c4123c60cffae6d56caf99b5acb2ef4f2495f557823dad4fe7c190f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bb7e7c9c4123c60cffae6d56caf99b5acb2ef4f2495f557823dad4fe7c190f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bb7e7c9c4123c60cffae6d56caf99b5acb2ef4f2495f557823dad4fe7c190f4"
    sha256 cellar: :any_skip_relocation, ventura:        "a5a2452f039b657b70c3dc8e35cc733b9b8b2a28e339da2e665083cd842d6bf2"
    sha256 cellar: :any_skip_relocation, monterey:       "a5a2452f039b657b70c3dc8e35cc733b9b8b2a28e339da2e665083cd842d6bf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5a2452f039b657b70c3dc8e35cc733b9b8b2a28e339da2e665083cd842d6bf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed6bef888ebfa16f7ecef992216d1f9d03e1f02f8b48f2a8369b176f76452623"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
