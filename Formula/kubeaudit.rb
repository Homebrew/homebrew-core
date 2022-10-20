class Kubeaudit < Formula
  desc "Helps audit your Kubernetes clusters against common security controls"
  homepage "https://github.com/Shopify/kubeaudit"
  url "https://github.com/Shopify/kubeaudit/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "352a1c9d3d3a2492da8ab4ab20b19185f2277112821eb72c3aa06cd1c10c6c4e"
  license "MIT"
  head "https://github.com/Shopify/kubeaudit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3793dd656348c6a6ad01be58f3810962bd2a90729f9b6e6caaa6a3a1aa7cf2d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "332f24d85e14e519c76b6307c75619629092e4782a2c54f5ad0cc51293e59858"
    sha256 cellar: :any_skip_relocation, monterey:       "dc4740989c98a422cb96fcb7eab978946187617081da323edb2881c3c8b792ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "13230bef7c93ce7110f98bd48cacbd9c0c00dd417a2f183002f221c5649c8412"
    sha256 cellar: :any_skip_relocation, catalina:       "6e8b6f6387186532a2b6aafe63afa70c633d91d43774688e04f353e3d898621e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd441cf15ae53a6c44f3199c0c082de9e78adc43bb2f00d2ea68e6e99c468e4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Shopify/kubeaudit/cmd.Version=#{version}
      -X github.com/Shopify/kubeaudit/cmd.BuildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kubeaudit", "completion")
  end

  test do
    output = shell_output(bin/"kubeaudit --kubeconfig /some-file-that-does-not-exist all 2>&1", 1).chomp
    assert_match "failed to open kubeconfig file /some-file-that-does-not-exist", output
  end
end
