class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/refs/tags/2.36.tar.gz"
  sha256 "a66e306c0289bac541af10cb88acc9b9576153de5d4acec566c3f927acefd778"
  license "ISC"
  head "https://github.com/piranha/gostatic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6f90c04fe4dae3f6edce58241bb7346f784e96f70cfb136a586bfb901e644bfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8c409dcbf4273866a153de5ca7f84d985eab10b4259c718ef4856206a6a49e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac8f00d4c297bec6e0276e2a3a5a287a0aeb3407794d63b296e14de3f6cfd814"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fee49b6f3e2a28ea13f71e318c63fdccfbfeea301290623c741602b4ba7efa42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee49b6f3e2a28ea13f71e318c63fdccfbfeea301290623c741602b4ba7efa42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee49b6f3e2a28ea13f71e318c63fdccfbfeea301290623c741602b4ba7efa42"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed125d328bd2511ad9b6fd3c81c29ab9f624122b1bb7d80e56ded13ee419e825"
    sha256 cellar: :any_skip_relocation, ventura:        "702b45e745c213901ee9bac69898a39fca340055bea4257ed12967563990d842"
    sha256 cellar: :any_skip_relocation, monterey:       "702b45e745c213901ee9bac69898a39fca340055bea4257ed12967563990d842"
    sha256 cellar: :any_skip_relocation, big_sur:        "702b45e745c213901ee9bac69898a39fca340055bea4257ed12967563990d842"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "25383ed9edc30c872a42d57184bc8555aac628c482eb8705ba7deed28f526050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc806119828adc0ed8433ff0dfdb9573f76bac686ffa19d368726d978d7aacb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"config").write <<~EOS
      TEMPLATES = site.tmpl
      SOURCE = src
      OUTPUT = out
      TITLE = Hello from Homebrew

      index.md:
      \tconfig
      \text .html
      \tmarkdown
      \ttemplate site
    EOS

    (testpath/"site.tmpl").write <<~EOS
      {{ define "site" }}
      <html><head><title>{{ .Title }}</title></head><body>{{ .Content }}</body></html>
      {{ end }}
    EOS

    (testpath/"src/index.md").write "Hello world!"

    system bin/"gostatic", testpath/"config"
    assert_path_exists testpath/"out/index.html"
  end
end
