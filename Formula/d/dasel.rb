class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "ba8da9569f38e7f33453c03ac988382291a01004a96c307d52cccadb9ef7837e"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "547a6243bd091b92e93455283210de56e8667de9b0fedf5222202ebb8f27e450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2114ccaf33e9ab0c7b9f6afeb321c2b3f67942b58c957bffeecf8a5720c09f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9654ac991b33c3d38161b7edd9943cd11fecff1b9045247f6449518fadd0e7de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5859fe2b673d13058594ea5fc6121eebeefe2ed88f675dbad0cb62f8b3586157"
    sha256 cellar: :any_skip_relocation, sonoma:         "78b72f42a4efd60990d9a4db870f29de9dd4b9e6ecacf08bb06af8be0a152f40"
    sha256 cellar: :any_skip_relocation, ventura:        "b2fc3507f7be3704bf7654819d96698c73173906209e1c85162ddb5abeeda663"
    sha256 cellar: :any_skip_relocation, monterey:       "070438b2bd8cdc5270e57c45aac9f65c39a96e915381b7bfba580e9163981266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eddbd2fc088504140c75552881571348a45c577380efbb059d8fd1077acb713f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
