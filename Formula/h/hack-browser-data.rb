class HackBrowserData < Formula
  desc "Command-line tool for decrypting and exporting browser data"
  homepage "https://github.com/moonD4rk/HackBrowserData"
  url "https://github.com/moonD4rk/HackBrowserData/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8efd8b28d85ef96683ee5f501e882685108ce78a8e128d42a194c949da74465f"
  license "MIT"
  head "https://github.com/moonD4rk/HackBrowserData.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3306f065ac1cc16c3b7413c2b9eeb461ea75028d056fcf9e7871c60877b018a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3306f065ac1cc16c3b7413c2b9eeb461ea75028d056fcf9e7871c60877b018a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3306f065ac1cc16c3b7413c2b9eeb461ea75028d056fcf9e7871c60877b018a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f95bb007e59bd617cf6dadaf0a653ec63378afd74bfd9f9ede855b4a27639591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc707b30d1f2661aaf375cfa65b52fb07ae4eb370867beda460b40c0554320fb"
    sha256 cellar: :any,                 x86_64_linux:  "0cd8211b663f69a5746c08e4edbb20411c137b72ce04610e8a468b050e042669"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hack-browser-data"

    generate_completions_from_executable(bin/"hack-browser-data", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hack-browser-data version")

    output = shell_output("#{bin}/hack-browser-data -b chrome -f json --dir #{testpath}/results 2>&1")
    assert_match "[WRN] no browsers found\n", output
  end
end
