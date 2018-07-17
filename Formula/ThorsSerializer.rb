class Thorsserializer < Formula
  desc "Declarative Serialization Library (Json/Yaml) for C++"
  homepage "https://github.com/Loki-Astari/ThorsSerializer"
  url "https://github.com/Loki-Astari/ThorsSerializer.git", :using => GitHubGitDownloadStrategy, :tag => "1.5.7"

  ENV["COV"] = "gcov"

  depends_on "libyaml"

  def install
    system "./configure", "--disable-binary", "--disable-vera", "--with-thor-build-on-travis", "--prefix=#{prefix}"
    system "make", "install"
  end
end
