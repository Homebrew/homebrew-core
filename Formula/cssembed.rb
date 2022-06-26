class Cssembed < Formula
  desc "Automatic data URI embedding in CSS files"
  homepage "https://www.nczonline.net/blog/2009/11/03/automatic-data-uri-embedding-in-css-files/"
  url "https://github.com/downloads/nzakas/cssembed/cssembed-0.4.5.jar"
  sha256 "8955016c0d32de8755d9ee33d365d1ad658a596aba48537a810ce62f3d32a1af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc0fbbbe0f39970282d0bbc7a3ec27abcff377cf6a4772948415ee9e018d509a"
  end

  deprecate! date: "2020-11-10", because: :repo_archived

  def install
    libexec.install "cssembed-#{version}.jar"
    bin.write_jar_script libexec/"cssembed-#{version}.jar", "cssembed"
  end
end
