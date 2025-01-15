class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "f571ed2d4713294a278b935249b9183b55c4e3e84093dc5ee537b926a04fac11"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3278560058e83d0db6a386d6a9ea0ebc4f680719e07ad57946ce751beb835076"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3278560058e83d0db6a386d6a9ea0ebc4f680719e07ad57946ce751beb835076"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3278560058e83d0db6a386d6a9ea0ebc4f680719e07ad57946ce751beb835076"
    sha256 cellar: :any_skip_relocation, sonoma:        "684498e068f6eebbb1b58ab626b6f9025a474b64c76964afdb0c4ba39fce9acf"
    sha256 cellar: :any_skip_relocation, ventura:       "684498e068f6eebbb1b58ab626b6f9025a474b64c76964afdb0c4ba39fce9acf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d1534a591e9fd0620ec8cc57bcba339e789bc21fcd44cffe3912d65311e8f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "no_self_update", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
