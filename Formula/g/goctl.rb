class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.7.2.tar.gz"
  sha256 "d97deb914f62baff8bb445af0d97017ce7a393d2cb01062ec419c46b6b03f8e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f4ceba5a3bdd24fc33d330be9ab113e5a184cc679d0ad68eebd74266de20bfa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7abf93331fdbf9819a61dfb3b2534ec5f3b1cfdc0d161cd6bdea442c64650bee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7abf93331fdbf9819a61dfb3b2534ec5f3b1cfdc0d161cd6bdea442c64650bee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7abf93331fdbf9819a61dfb3b2534ec5f3b1cfdc0d161cd6bdea442c64650bee"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1e8edf1c55022d6626e71acdb0abc803e2dc5450da1ffcde22531c1b4aebdb3"
    sha256 cellar: :any_skip_relocation, ventura:        "a1e8edf1c55022d6626e71acdb0abc803e2dc5450da1ffcde22531c1b4aebdb3"
    sha256 cellar: :any_skip_relocation, monterey:       "a1e8edf1c55022d6626e71acdb0abc803e2dc5450da1ffcde22531c1b4aebdb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44a35877c7f645b271710cef0c8ebbc163c72ea5ff9d930a7d1c011f9a37c5f2"
  end

  depends_on "go" => :build

  # bump to use go1.23, upstream patch PR, https://github.com/zeromicro/go-zero/pull/4279
  patch do
    url "https://github.com/zeromicro/go-zero/commit/19c5fc3c29335df2f452d0947b6740337abb94ce.patch?full_index=1"
    sha256 "0cc51959505721b4978d90f2990c93dfb3c00dda2ffbb8416c589c277e3971fb"
  end

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    # configure project path
    %w[api model rpc docker kube mongo newapi gateway].each do |f|
      mkdir_p testpath/"#{version}/#{f}"
    end
    system bin/"goctl", "template", "init", "--home=#{testpath}"
    assert_predicate testpath/"api/main.tpl", :exist?, "goctl install fail"
  end
end
