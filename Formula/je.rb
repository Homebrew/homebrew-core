class Je < Formula
  desc "Fast JSON to TSV/CSV/JSON/User-defined-format Extractor"
  homepage "https://github.com/tamediadigital/je"
  head "https://github.com/tamediadigital/je.git"
  
  JE_VER = "0.0.1"
  ASDF_VER = "0.1.4"
  HLL_D_VER = "0.3.1"
  MIR_ALGORITHM_VER = "0.6.13"
  MIR_RANDOM_VER = "0.2.5"

  url "https://github.com/tamediadigital/je/archive/v#{JE_VER}.tar.gz"
  sha256 "5217ec2fc91a1817d2dc3da05c78867a94aaf281c8e664103238c416b886bce5"

  resource "asdf" do
    url "https://github.com/tamediadigital/asdf/archive/v#{ASDF_VER}.tar.gz"
    sha256 "ffce4e1819009ad5695e17546ee82a8a64e036e7ca0398da2cc5787dfa7a71d1"
  end

  resource "hll-d" do
    url "https://github.com/tamediadigital/hll-d/archive/v#{HLL_D_VER}.tar.gz"
    sha256 "9f75a8079d06782bcb6a5c4fba2a7da18ecf595106baecfd805a0cd55373b245"
  end

  resource "mir-algorithm" do
    url "https://github.com/libmir/mir-algorithm/archive/v#{MIR_ALGORITHM_VER}.tar.gz"
    sha256 "06ac713e6ddfef48acee995e5dd7078828bcb8dd3a84a5b87c6dcd1c4e3a980f"
  end

  resource "mir-random" do
    url "https://github.com/libmir/mir-random/archive/v#{MIR_RANDOM_VER}.tar.gz"
    sha256 "ca30fcfd64903c226c371cd5caa7fb87a1378c1b18ab310a4447a9cccf53891d"
  end

  depends_on "dub" => :build
  depends_on "ldc" => :build

  def install

    selection = {
      "fileVersion" => 1,
      "versions" => {}
    }

    ["asdf", "hll-d", "mir-algorithm", "mir-random"].each do |dependency|
      resource(dependency).stage(File.join(Dir.pwd, dependency))
      selection["versions"][dependency] = {"path" => dependency}
    end
  
    File.open("dub.selections.json", 'w') do |f|
      f.write(selection.to_json)
    end

    compiler = "ldmd2"
    system "dub", "build", "--compiler=" + compiler, "--build=release-native"
    bin.install "je"
  end

  test do
    (testpath/"in.jsonl").write <<-EOS.undent
      {"a":{"b":"\n"}, "d":2}
      {"a":{"b":0}, "d":1}
      {"a":{"b":2}}
    EOS
    (testpath/"check.jsonl").write <<-EOS.undent
      {"a":"\n","t":2}
      {"a":0,"t":1}
      {"a":2,"t":null}
    EOS
    system "#{bin}/je" "-c" "a.b,d" "--out=$'{\"a\":%s,\"t\":%s}\n'"  "-i" "in.jsonl" "-o" "out.jsonl"
    assert_equal (testpath/"check.jsonl").read, (testpath/"out.jsonl").read
  end

end
