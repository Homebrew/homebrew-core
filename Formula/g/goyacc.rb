class Goyacc < Formula
  desc "Parser Generator for Go"
  homepage "https://pkg.go.dev/modernc.org/goyacc"
  url "https://gitlab.com/cznic/goyacc/-/archive/v1.0.3/goyacc-v1.0.3.tar.bz2"
  sha256 "a999dd35759dfa35cc2cff70b840db0cd41443ef7aff7b090ac170731e6a6c6c"
  license "BSD-3-Clause"
  head "https://gitlab.com/cznic/goyacc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c200a6f48e69a0a02aaa20cb0face2d581c44fdc868517beb5eed571074ebcc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b225608148f3a4a021cf2c97288a15a0896f98772c89f2908c8abb359ffb0138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b225608148f3a4a021cf2c97288a15a0896f98772c89f2908c8abb359ffb0138"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b225608148f3a4a021cf2c97288a15a0896f98772c89f2908c8abb359ffb0138"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9b364cae415d90c5c3a38cbe6e214ad339933905cc27e330cc01c70bd136c70"
    sha256 cellar: :any_skip_relocation, ventura:       "a9b364cae415d90c5c3a38cbe6e214ad339933905cc27e330cc01c70bd136c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f917d02474549576bd9f407dd870649cbbd7dcd6a8696bccd33220593ada1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16bab84f275141c4258582ae879d9ca737c2ad94d0ca2d1997672b4523778be7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{
      package main
      %}

      %union { val int }
      %token <val> NUM
      %type <val> expr term factor

      %%
      expr : expr '+' term { $$ = $1 + $3; }
          | term          { $$ = $1; }
          ;
      term : term '*' factor { $$ = $1 * $3; }
          | factor          { $$ = $1; }
          ;
      factor : '(' expr ')'  { $$ = $2; }
            | NUM           { $$ = $1; }
            ;
      %%
    EOS

    system bin/"goyacc", "-o", "test.go", "test.y"
    assert_match "package main", (testpath/"test.go").read
  end
end
