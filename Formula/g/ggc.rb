class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "c7a19b0a2e7df4b1f43e2d56cc49a0268138af16a9cbb949f2eefdafaa0581c6"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47f5ea5b465f1e39ef7e0a1bd1e6e014b38bbca700f7473b80a81498e8d45536"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47f5ea5b465f1e39ef7e0a1bd1e6e014b38bbca700f7473b80a81498e8d45536"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47f5ea5b465f1e39ef7e0a1bd1e6e014b38bbca700f7473b80a81498e8d45536"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47f5ea5b465f1e39ef7e0a1bd1e6e014b38bbca700f7473b80a81498e8d45536"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5fefe8afd183d71dbdef8c32e077d05f3f742362c96d0eac342fc981ef15c91"
    sha256 cellar: :any_skip_relocation, ventura:       "d5fefe8afd183d71dbdef8c32e077d05f3f742362c96d0eac342fc981ef15c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b8d44d63c68828d538cac6559a46db24e51489a302bc6ec056184485c355f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76c9290b6f83a1ea8ede1e7903de5668abd5a51103485e5b79dd6395e6d87b9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
