class Exomizer < Formula
  desc "6502 compressor with CBM PET 4032 support"
  homepage "https://bitbucket.org/magli143/exomizer/wiki/Home"
  url "https://bitbucket.org/magli143/exomizer/wiki/downloads/exomizer-3.0.1.zip"
  sha256 "82b68de9de4b9ac07599fcc961b401e6e545d1c6d6ac7fe564d29760b1008a78"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb996d43879386e136aa04b484f48c1838d36ce27f254823829c7213a6136d35" => :mojave
    sha256 "6b429036fa98cd25f0bac0bff18910a88e40423fdd6b21645526eb43f63e6ad4" => :high_sierra
    sha256 "f2a9e57c54a37a16298e33df0f43a290358df4daa683e33182bbb51660370bd8" => :sierra
    sha256 "1e0320a30f23c616069326fe176d49fee7bb10e1910ebe4ce4accb5306540475" => :el_capitan
  end

  def install
    cd "src" do
      system "make"
      bin.install %w[exobasic exomizer]
    end
  end

  test do
    output = shell_output(bin/"exomizer -v")
    assert_match version.to_s, output
  end
end
