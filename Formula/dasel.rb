class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.27.3.tar.gz"
  sha256 "1dfd0bf372ab252931adc636887c1d34a75e9ac767b5e6baabf9fd91fdfa15a6"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a196bb46bbc5b0436d47d448aa1223857ce58690d884ecc896a0a0be8d230ccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21086f7f67cc0ad457475b7ac97464cfb77aa0473133f3bac0e03642d79304f9"
    sha256 cellar: :any_skip_relocation, monterey:       "093edd26d35afc44c4dd59496966f17e295a0f4afae07cc2a4db49836a8f41a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "390ede644f4902baf4461f77f1299c21bc35381376ac60fd3adb14c17964c067"
    sha256 cellar: :any_skip_relocation, catalina:       "1cb975ce85dca8e1c234f3e3995ce399e558a585afaef6bbcfe78f7290f9f36f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4feec3f1613fa0a337dd7fae0fd230554aec0a6fdec952230ff3fd9453462e1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
