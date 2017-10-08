class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8c/41/b08e2883c256d52f63f00f622cf8a33d3bf36bb5714af337e67476f8b3fe/doitlive-2.8.0.tar.gz"
  sha256 "0f9a17955ea0877388610cefdc32bb260b51f81d56983fa60ebbf1b084137cca"

  bottle do
    cellar :any_skip_relocation
    sha256 "d00aca7443f624804d3d52983e2dad73759597cb8ebcd03a2da848cbc1701ea3" => :high_sierra
    sha256 "e5041e5134744e17de19ff0affd1fe71c2fb42408ee9eb0973f0549e1a45a1e0" => :sierra
    sha256 "54e6f6d771d1880d8c4e364057ab2392be02af073918c719590c154cf055a690" => :el_capitan
    sha256 "54e6f6d771d1880d8c4e364057ab2392be02af073918c719590c154cf055a690" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
