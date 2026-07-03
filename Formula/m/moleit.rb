class MoleIt < Formula
  desc 'CLI tool for scaffolding C and C++ projects, inspired by cargo init'
  homepage 'https://github.com/Jayesh-Dev21/MoleIt'
  url 'https://moleit.vercel.app/rel/v0.1.0.tar.gz'
  sha256 '0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5'
  license 'MIT'

  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'fmt'

  def install
    system 'cmake', '-S', '.', '-B', 'build', '-G', 'Ninja',
           '-DCMAKE_BUILD_TYPE=Release',
           "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system 'cmake', '--build', 'build', '-j'
    system 'cmake', '--install', 'build'
  end

  test do
    system "#{bin}/moleit", '--version'
  end
end
