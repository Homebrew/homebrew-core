class Chdig < Formula
  desc "Dig into ClickHouse with TUI interface"
  homepage "https://github.com/azat/chdig"
  url "https://github.com/azat/chdig/archive/refs/tags/v25.11.1.tar.gz"
  sha256 "3e84542afe61ef6bb0e7364fac0b08b8d652d1a81a4514ec1036056589c8d6aa"
  license "MIT"
  head "https://github.com/azat/chdig.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39910eedc4660dafd48ba30d6d4a6ebb352b756a617535b3d056406c0a987df5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1080f54b7d4885e10a1ad941b704d40b67cf97e23db944960427e40017a4dbf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "052bffd1ca78a0089b6523cf040476da25f0fecaafc07a5f99827d7f5a5972bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4dce2741c885ced576be6bd8992e3a58b06f5f31191f07893e40e7ad65fd7861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4423e02a9f19f9bbbcd830a62ea72c392181fb00acecbf347744e0096b93acc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae1564ceb97c3987ffeee7585eb864a8653c05fc8e8458f48e91947c8a7b741f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"chdig", "--completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chdig --version")

    # failed with Linux CI, `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/chdig --url 255.255.255.255 dictionaries 2>&1", 1)
    assert_match "Error: Cannot connect to ClickHouse", output
  end
end
