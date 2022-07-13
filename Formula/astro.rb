class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "578410a9dcda1797ff223601317afbc636ca546d6de4998c899e3e347b229be4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80787d033a4b8cad3d41588be9d679945c0837a6d8235f0ee01bc223aafb3a68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80787d033a4b8cad3d41588be9d679945c0837a6d8235f0ee01bc223aafb3a68"
    sha256 cellar: :any_skip_relocation, monterey:       "5a70dbcb44b946dab19a3f1d82f1bb3936c82bfc6dd13e2e260d1d7bfc4e0dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a70dbcb44b946dab19a3f1d82f1bb3936c82bfc6dd13e2e260d1d7bfc4e0dce"
    sha256 cellar: :any_skip_relocation, catalina:       "5a70dbcb44b946dab19a3f1d82f1bb3936c82bfc6dd13e2e260d1d7bfc4e0dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da1c9a114d605d9ae070ada430fe9af8e80382024f8019b3ec0f62f321710078"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")
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
