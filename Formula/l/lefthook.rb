class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "5d152b84e6a1aecd1d3173865a69f0466d1c166c3978ce6e679293194973b845"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6ad15bc418a1177b295b12f9207f9562816c6c3f12e91440ce36776cee3073e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6ad15bc418a1177b295b12f9207f9562816c6c3f12e91440ce36776cee3073e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6ad15bc418a1177b295b12f9207f9562816c6c3f12e91440ce36776cee3073e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdf9438f72d207f1044d0c28e2db993ac169353932f95a92d8f2f3a3eaed15a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbea48259d564cb072e7d1f9a008832538f65544c4014ac38a48b06ca4a68239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd0e1be912d185a681b1cb598f96701e718fd0648cfeaa7655603d65105d8f5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
