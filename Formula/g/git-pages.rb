class GitPages < Formula
  desc "Scalable static site server for Git forges"
  homepage "https://codeberg.org/git-pages/git-pages"
  url "https://codeberg.org/git-pages/git-pages/releases/download/v0.9.1/git-pages-src.zip"
  sha256 "f9c71aa5be211cbd7e03637ec7455e124e05e5cabb040f09e05e188358c2ea00"
  license "0BSD"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47884eb988b8c1f9f67b31f70019edb23cf062464f3f24decbab3033aaee5181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61dc595ab2e2c4ee6c9499e4c141563ecabd4b704822c16b485617572e7cb082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a5bc464ffe4131cbaef9b9114994b1932023fdef5c09ef959dadea84af3a38"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ca54050c1ce211edaf0cdee3bdd645dae7e06dfc48e5e552bffaa26e9f447d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4570a841130d38a14b786237304933149a547aa519d74280ac1c2c06640cda18"
    sha256 cellar: :any,                 x86_64_linux:  "c2804e9c8cebc738376f632c73cb9f85dc58a38a1d0435f2ad6838c778cf74ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    mkdir_p "data"
    port = free_port

    (testpath/"config.toml").write <<~TOML
      [server]
      pages = "tcp/localhost:#{port}"
    TOML

    ENV["PAGES_INSECURE"] = "1"

    spawn bin/"git-pages"

    sleep 2
    system "curl", "http://127.0.0.1:#{port}", "-X", "PUT", "-d", "https://codeberg.org/git-pages/git-pages.git"

    sleep 2
    assert_equal "It works!\n", shell_output("curl http://127.0.0.1:#{port}")
  end
end
